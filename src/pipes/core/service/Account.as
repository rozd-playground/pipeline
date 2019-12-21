/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 11:59 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.service
{
import flash.events.NetStatusEvent;

import pipes.core.config.ConfigDefaults;
import pipes.core.connection.Connection;
import pipes.core.events.ConnectionEvent;
import pipes.core.remoting.Remoting;
import pipes.domain.Responder;
import pipes.domain.User;

public class Account
{
    private static var instance:Account;

    public static function get account():Account
    {
        if (!instance)
            instance = new Account();

        return instance;
    }

    public function Account()
    {
        super();

        remoting = new ConfigDefaults.remoting();
        Connection.connection.addEventListener(ConnectionEvent.PEER_ID_CHANGED, peerIdChangedHandler);
    }

    private var remoting:Remoting;

    private var _current:User;

    public function get current():User
    {
        return _current;
    }

    public function login(username:String, responder:Responder):void
    {
        remoting.login(username, new Responder(
            function (data:Object):void
            {
                _current = new User();
                _current.userId = username;
                _current.peerId = Connection.connection.getPeerId();

                responder.result(data);
            },
            function (info:Object):void
            {
                _current = null;

                responder.fault(info);
            })
        );
    }


    public function getContactList(responder:Responder):void
    {
        remoting.getContactList(responder);
    }

    public function getPeerId(user:User, responder:Responder):void
    {
        remoting.getContact(user.userId, new Responder(
            function(data:User):void
            {
                responder.result(data.peerId);
            },
            function(info:Object):void
            {
                responder.fault(info);
            })
        );
    }

    private function updatePeerId():void
    {
        _current.peerId = Connection.connection.getPeerId();

        remoting.updateUser(_current, new Responder(
            function (data:Object):void
            {

            },
            function (info:Object):void
            {
                _current = null;
            })
        );
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------


    private function peerIdChangedHandler(event:ConnectionEvent):void
    {
        updatePeerId();
    }
}
}
