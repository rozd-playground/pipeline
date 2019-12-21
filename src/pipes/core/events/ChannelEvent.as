/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 10:57 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.events
{
import flash.events.Event;

public class ChannelEvent extends Event
{
    public static const MESSAGE_RECEIVED:String = "messageReceived";

    public static const CHANNEL_ACTIVATE:String = "channelActivate";

    public function ChannelEvent(type:String, data:Object=null, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);

        this.data = data;
    }

    public var data:Object;
}
}
