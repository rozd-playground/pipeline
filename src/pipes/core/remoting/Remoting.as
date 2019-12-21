/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 12:04 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.remoting
{
import pipes.domain.Responder;
import pipes.domain.User;

public interface Remoting
{
    // auth

    function login(username:String, responder:Responder):void;

    function logout(responder:Responder):void;

    // user

    function updateUser(user:User, responder:Responder):void;

    // replication

    function getNextReplicationIndex(chunks:Number, responder:Responder):void;

    function clearReplicationIndex(index:Number, responder:Responder):void;

    // contacts

    function getContact(userId:String, responder:Responder):void;

    function getContactList(responder:Responder):void;
}
}
