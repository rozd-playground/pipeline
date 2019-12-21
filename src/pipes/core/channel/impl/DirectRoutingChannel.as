/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 10:59 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.channel.impl
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.NetStatusEvent;
import flash.net.NetGroup;

import pipes.core.channel.Channel;
import pipes.core.config.PipeContext;
import pipes.core.events.ChannelEvent;
import pipes.core.session.Session;
import pipes.domain.Message;
import pipes.domain.Sendable;

public class DirectRoutingChannel extends EventDispatcher implements Channel
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const GROUP_HEADER:String = "group";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function DirectRoutingChannel()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var session:Session;

    private var group:NetGroup;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _activate:Boolean;

    public function get activate():Boolean
    {
        return _activate;
    }

    private function setActivate(value:Boolean):void
    {
        if (value == _activate) return;

        _activate = value;

        if (_activate)
        {
            dispatchEvent(new ChannelEvent(ChannelEvent.CHANNEL_ACTIVATE));
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function init(info:PipeContext):void
    {
        session = info.session;

        session.addEventListener(Event.CONNECT, connectHandler, false, 0, true);

        setupGroup(session.getNetGroup());
    }

    private function setupGroup(group:NetGroup):void
    {
        if (this.group)
        {
            this.group.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        }

        this.group = group;

        if (this.group)
        {
            this.group.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        }

        this.setActivate(this.group != null);
    }

    public function dispose():void
    {
        if (group)
        {
            group.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            group = null;
        }
    }

    public function send(message:Sendable):void
    {
        message.headers[GROUP_HEADER] = group.convertPeerIDToGroupAddress(message.recipient.peerId);

        group.sendToNearest(message, message.headers[GROUP_HEADER]);
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function connectHandler(event:Event):void
    {
        this.setupGroup(session.getNetGroup());
    }

    private function netStatusHandler(event:NetStatusEvent):void
    {
        switch (event.info.code)
        {
            case "NetGroup.SendTo.Notify" :

                if (event.info.fromLocal)
                {
                    dispatchEvent(new ChannelEvent(ChannelEvent.MESSAGE_RECEIVED, event.info.message));
                }
                else
                {
                    group.sendToNearest(event.info.message, event.info.message.headers[GROUP_HEADER]);
                }

                break;

            case "NetGroup.Posting.Notify" :

                dispatchEvent(new ChannelEvent(ChannelEvent.MESSAGE_RECEIVED, event.info.message));

                break;
        }
    }

}
}
