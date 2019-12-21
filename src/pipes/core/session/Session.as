/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 5/23/13
 * Time: 3:09 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.session
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.NetStatusEvent;
import flash.events.StatusEvent;
import flash.net.GroupSpecifier;
import flash.net.NetConnection;
import flash.net.NetGroup;

import pipes.core.config.PipeContext;

import pipes.core.connection.Connection;
import pipes.core.connection.ConnectionStatus;
import pipes.core.utils.DelayUtil;


[Event(name="connect", type="flash.events.Event")]

[Event(name="status", type="flash.events.StatusEvent")]

public class Session extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Session()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var connection:Connection;

    private var group:NetGroup;

    private var specifier:GroupSpecifier;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _name:String;

    public function get name():String
    {
        return _name;
    }

    private var _status:String;

    public function get status():String
    {
        return _status;
    }

    private function setStatus(value:String):void
    {
        if (value == _status)
            return;

        _status = value;

        trace("Session.status:", value);

        if (_status == SessionStatus.ACTIVE)
        {
            this.dispatchEvent(new Event(Event.CONNECT));
        }

        this.dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, value, "status"));
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function getNetGroup():NetGroup
    {
        return group;
    }

    public function getSpecifier():GroupSpecifier
    {
        return specifier;
    }

    public function init(info:PipeContext):void
    {
        _name = info.name;
        connection = info.connection;

        specifier = new GroupSpecifier(_name);
//        specifier.ipMulticastMemberUpdatesEnabled = true;
        specifier.multicastEnabled = true;
        specifier.postingEnabled = true;
        specifier.routingEnabled = true;
        specifier.serverChannelEnabled = true;
        specifier.objectReplicationEnabled = true;
    }

    public function dispose():void
    {
        var nc:NetConnection = connection.getNetConnection();
        nc.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);

        if (group)
        {
            group.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            group.close();
            group = null;
        }

        setStatus(SessionStatus.READY);
    }

    public function activate():void
    {
        if (_status == SessionStatus.ACTIVE || _status == SessionStatus.CONNECT)
            return;

        setStatus(SessionStatus.CONNECT);

        if (connection.status != ConnectionStatus.ACTIVE)
        {
            DelayUtil.delayToEvent(connection, Event.CONNECT, this.doActivate);
        }
        else
        {
            doActivate();
        }

        connection.activate();
    }

    private function doActivate():void
    {
        var nc:NetConnection = connection.getNetConnection();
        nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);

        group = new NetGroup(nc, specifier.groupspecWithAuthorizations());
        group.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
    }

    public function deactivate():void
    {
        if (_status == SessionStatus.SUSPENDED)
            return;

        setStatus(SessionStatus.SUSPENDED);

        var nc:NetConnection = connection.getNetConnection();
        nc.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);

        if (group)
        {
            group.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            group.close();
            group = null;
        }

        connection.deactivate();
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function netStatusHandler(event:NetStatusEvent):void
    {
        trace(event.info.code);

        switch (event.info.code)
        {
            case "NetGroup.Connect.Success": // e.info.group

                setStatus(SessionStatus.ACTIVE);

                break;

            case "NetGroup.Connect.Rejected": // e.info.group
            case "NetGroup.Connect.Failed": // e.info.group

                setStatus(SessionStatus.ERROR);

                break;

            case "NetGroup.Neighbor.Connect" :

                trace(event.info.peerID);

                break;
        }
    }
}
}
