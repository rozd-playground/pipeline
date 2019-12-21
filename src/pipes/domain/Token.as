/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 12:27 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.domain
{
import pipes.core.utils.*;

import flash.events.EventDispatcher;

public class Token extends EventDispatcher
{
    public function Token()
    {
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    //
    //--------------------------------------------------------------------------

    protected var responders:Array;

    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------

    public function addResponder(responder:Responder):void
    {
        if (!responders)
            responders = [];

        responders.push(responder);
    }

    public function applyResult(result:Object):void
    {
        if (!responders) return;

        for (var i:int = 0, n:int = responders.length; i < n; i++)
        {
            var responder:Responder = responders[i] as Responder;

            if (responder)
            {
                responder.result(result);
            }
        }
    }

    public function applyFault(fault:Object):void
    {
        if (!responders) return;

        for (var i:int = 0, n:int = responders.length; i < n; i++)
        {
            var responder:Responder = responders[i] as Responder;

            if (responder)
            {
                responder.fault(fault);
            }
        }
    }

//    public function applyCancel(fault:Object):void
//    {
//        if (!responders) return;
//
//        for (var i:int = 0, n:int = responders.length; i < n; i++)
//        {
//            var responder:Responder = responders[i];
//
//            if (responder)
//            {
//                responder.fault(fault);
//            }
//        }
//    }
//
//    public function applyTimeout(fault:Object):void
//    {
//        if (!responders) return;
//
//        for (var i:int = 0, n:int = responders.length; i < n; i++)
//        {
//            var responder:Responder = responders[i];
//
//            if (responder)
//            {
//                responder.fault(fault);
//            }
//        }
//    }

}
}
