/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 5/23/13
 * Time: 3:45 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.connection
{
import flash.events.AsyncErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.net.NetConnection;

import pipes.core.events.ConnectionEvent;

[Event(name="connect", type="flash.events.Event")]
[Event(name="status", type="flash.events.StatusEvent")]
[Event(name="peerIdChanged", type="pipes.core.events.ConnectionEvent")]

public class Connection extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    private static var _server:String;

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    private static var _connection:Connection;

    public static function get connection():Connection
    {
        if (!_connection)
            _connection = new Connection();

        return _connection;
    }

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    public static function prepare(server:String):void
    {
        _server = server;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Connection()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var connection:NetConnection;

    private var peerId:String;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _status:String = ConnectionStatus.INACTIVE;

    public function get status():String
    {
        return _status;
    }

    private function setStatus(value:String):void
    {
        if (value == _status)
            return;

        _status = value;

        trace("Connection.status:", value);

        if (_status == ConnectionStatus.ACTIVE)
            this.dispatchEvent(new Event(Event.CONNECT));

        this.dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, value, "status"));
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function getNetConnection():NetConnection
    {
        return connection;
    }

    public function getPeerId():String
    {
        return connection && connection.connected ? connection.nearID : null;
    }

    public function activate():void
    {
        if (_status == ConnectionStatus.ACTIVE || _status == ConnectionStatus.CONNECT)
            return;

        setStatus(ConnectionStatus.CONNECT);

        connection = new NetConnection();
        connection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
        connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        connection.connect(_server);
    }

    public function deactivate():void
    {
        if (_status == ConnectionStatus.INACTIVE)
            return;

        setStatus(ConnectionStatus.INACTIVE);

        connection.close();
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function netStatusHandler(event:NetStatusEvent):void
    {
        switch (event.info.code)
        {
            case "NetConnection.Connect.Success" :

                setStatus(ConnectionStatus.ACTIVE);

                if (peerId != connection.nearID)
                {
                    peerId = connection.nearID;

                    dispatchEvent(new ConnectionEvent(ConnectionEvent.PEER_ID_CHANGED));
                }

                break;

            case "NetConnection.Connect.NetworkChange" :

                if (peerId != connection.nearID)
                {
                    peerId = connection.nearID;

                    dispatchEvent(new ConnectionEvent(ConnectionEvent.PEER_ID_CHANGED));
                }

                break;

            case "NetConnection.Connect.Closed" :

                setStatus(ConnectionStatus.INACTIVE);

                break;
        }
    }

    private function ioErrorHandler(event:IOErrorEvent):void
    {
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void
    {

    }

    private function asyncErrorHandler(event:AsyncErrorEvent):void
    {

    }
}
}
