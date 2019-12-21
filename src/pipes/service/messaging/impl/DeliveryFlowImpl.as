/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/27/13
 * Time: 10:25 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.service.messaging.impl
{
import pipes.core.routing.Router;
import pipes.core.service.Account;
import pipes.domain.CancelResponder;
import pipes.domain.Fault;
import pipes.domain.Message;
import pipes.domain.Responder;
import pipes.domain.Token;
import pipes.service.messaging.Delivery;
import pipes.service.messaging.DeliveryFlow;

/**
 *
 */
public class DeliveryFlowImpl implements DeliveryFlow
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function DeliveryFlowImpl(router:Router)
    {
        super();

        this.router = router;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    // core objects

    private var router:Router;

    // data

    private var message:Message;
    private var delivery:Delivery;

    // flags

    private var isCanceled:Boolean = false;
    private var isPeerIdUpdated:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /** @inheritDoc */
    public function send(message:Message):Token
    {
        this.message = message;

        createDelivery();

        if (message.recipient.online)
        {
            sendMessage(message);
        }
        else
        {
            updatePeerId();
        }

        return delivery;
    }

    /** Creates delivery and  */
    private function createDelivery():void
    {
        delivery = new Delivery();

        delivery.addCancelResponder(new CancelResponder(
            function (info:Object):void
            {
                isCanceled = true;

                router.cancel(message);
            })
        )
    }

    private function tryAgain():void
    {
        if (isCanceled) return;

        if (isPeerIdUpdated)
        {
            delivery.applyFault(Fault.createTimeoutFault())
        }
        else
        {
            updatePeerId();
        }
    }

    private function updatePeerId():void
    {
        if (isCanceled) return;

        isPeerIdUpdated = true;

        Account.account.getPeerId(message.recipient, new Responder(function (data:Object):void
            {
                message.recipient.peerId = data as String;

                sendMessage(message);
            },
            function (info:Object):void
            {
                delivery.applyFault(info);
            })
        )
    }

    private function sendMessage(message:Message):void
    {
        if (isCanceled) return;

        var t:Token = router.send(message);
        t.addResponder(new Responder(
            function (data:Object):void
            {
                delivery.applyResult(data);
            },
            function (info:Object):void
            {
                tryAgain();
            })
        )
    }
}
}
