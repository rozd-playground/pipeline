/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 11:07 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.domain
{
public class Message extends SendableBase
{
    public function Message()
    {
    }

    private var _body:Object;

    public function get body():Object
    {
        return _body;
    }

    public function set body(value:Object):void
    {
        _body = value;
    }
}
}
