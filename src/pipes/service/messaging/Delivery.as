/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 6:26 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.service.messaging
{
import pipes.domain.CancelResponder;
import pipes.domain.Fault;
import pipes.domain.Responder;
import pipes.domain.Token;

public class Delivery extends Token
{
    public function Delivery()
    {
        super();
    }

    public function addCancelResponder(responder:CancelResponder):void
    {
        if (!responders)
            responders = [];

        this.responders.push(responder);
    }

    private var token:Token;

    public function cancel():void
    {
        applyCancel(Fault.createCancelFault());
    }

    public function applyCancel(fault:Fault):void
    {
        if (!responders) return;

        for (var i:int = 0, n:int = responders.length; i < n; i++)
        {
            var responder:CancelResponder = responders[i];

            if (responder)
            {
                responder.cancel(fault);
            }
        }
    }
}
}
