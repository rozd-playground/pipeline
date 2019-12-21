/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 10:57 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.domain
{
public interface Sendable
{
    function get objectId():String;
    function set objectId(value:String):void;

    function get headers():Object;
    function set headers(value:Object):void;

    function get sender():User;
    function set sender(value:User):void;

    function get recipient():User;
    function set recipient(value:User):void;
}
}
