/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 1:26 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.domain
{
import flash.events.EventDispatcher;

public class SendableBase extends EventDispatcher implements Sendable
{
    public function SendableBase()
    {
    }

    private var _objectId:String

    public function get objectId():String
    {
        return _objectId;
    }

    public function set objectId(value:String):void
    {
        _objectId = value;
    }

    private var _headers:Object = {};

    public function get headers():Object
    {
        return _headers;
    }

    public function set headers(value:Object):void
    {
        _headers = value;
    }

    private var _sender:User;

    public function get sender():User
    {
        return _sender;
    }

    public function set sender(value:User):void
    {
        _sender = value;
    }

    private var _recipient:User;

    public function get recipient():User
    {
        return _recipient;
    }

    public function set recipient(value:User):void
    {
        _recipient = value;
    }
}
}
