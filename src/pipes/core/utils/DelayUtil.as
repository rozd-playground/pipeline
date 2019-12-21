/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 5/23/13
 * Time: 6:23 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.utils
{
import flash.events.TimerEvent;
import flash.utils.Timer;

public class DelayUtil
{
    public static function delayToEvent(dispatcher:Object, event:String, callback:Function, ...args):void
    {
        dispatcher.addEventListener(event,
            function handler(e:Object):void
            {
                dispatcher.removeEventListener(event, handler);

                callback.apply(null, args);
            }
        );
    }

    public static function delayToTimeout(timeout:uint, callback:Function, ...args):void
    {
        var timer:Timer = new Timer(timeout, 1);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE,
            function handler(e:Object):void
            {
                timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handler);

                callback.apply(null, args);
            }
        );
        timer.start();
    }

    public static function createDelayedTask(tasks:Vector.<DelayedCall>, method:Function, ...params):Boolean
    {
        var task:DelayedCall = new DelayedCall(method, params);

        for (var i:int = 0, n:int = tasks.length; i < n; i++)
        {
            var task:DelayedCall = tasks[i];

            if (tasks[i].equalTo(task))
                return false;
        }

        tasks.push(task);

        return true;
    }

    public static function proceedDelayedTasks(tasks:Vector.<DelayedCall>):void
    {
        for (var i:int = 0, n:int = tasks.length; i < n; i++)
        {
            tasks[i].invoke();
        }

        tasks.length = 0;
    }
}
}
