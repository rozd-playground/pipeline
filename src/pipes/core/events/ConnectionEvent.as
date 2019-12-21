/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 3:40 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.events
{
import flash.events.Event;

public class ConnectionEvent extends Event
{
    public static const PEER_ID_CHANGED:String = "peerIdChanged";

    public function ConnectionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }
}
}
