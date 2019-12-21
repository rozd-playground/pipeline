/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 12:06 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.remoting.impl
{
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;

import pipes.core.remoting.*;
import pipes.domain.Responder;
import pipes.domain.Token;
import pipes.domain.User;

public class DefaultRemoting implements Remoting
{
    public function DefaultRemoting()
    {
    }

    public function login(username:String, responder:Responder):void
    {
        var token:Token = new DefaultOperation("http://localhost:3000/api/1.0/login").post({username:username});
        token.addResponder(responder);
    }

    public function logout(responder:Responder):void
    {
        var token:Token = new DefaultOperation("http://localhost:3000/api/1.0/logout").get();
        token.addResponder(responder);
    }

    public function updateUser(user:User, responder:Responder):void
    {
        var token:Token = new DefaultOperation("http://localhost:3000/api/1.0/user").post(user);
        token.addResponder(responder);
    }

    public function getNextReplicationIndex(chunks:Number, responder:Responder):void
    {
    }

    public function clearReplicationIndex(index:Number, responder:Responder):void
    {
    }

    public function getContactList(responder:Responder):void
    {
        var token:Token = new DefaultOperation("http://localhost:3000/api/1.0/user/").get();
        token.addResponder(new Responder(
            function(data:Object):void
            {
                var users:Array = [];
                for each (var o:Object in data)
                {
                    var user:User = new User();
                    user.userId = o.userId;
                    user.peerId = o.peerId;

                    users.push(user);
                }

                responder.result(users);
            },
            function(info:Object):void
            {
                responder.fault(info);
            })
        );
    }

    public function getContact(userId:String, responder:Responder):void
    {
        var token:Token = new DefaultOperation("http://localhost:3000/api/1.0/user/" + userId).get();
        token.addResponder(new Responder(
            function(data:Object):void
            {
                var user:User = new User();
                user.userId = data.userId;
                user.peerId = data.peerId;

                responder.result(user);
            },
            function(info:Object):void
            {
                responder.fault(info);
            })
        );
    }
}
}
