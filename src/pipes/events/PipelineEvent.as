/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 12:08 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.events
{
import flash.events.Event;

public class PipelineEvent extends Event
{
    public static const LOGIN:String = "login";

    public static const LOGOUT:String = "logout";

    public function PipelineEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }
}
}
