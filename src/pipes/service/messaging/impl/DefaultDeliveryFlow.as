/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 12:32 PM
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
import pipes.service.messaging.DeliveryFlow;

public class DefaultDeliveryFlow implements DeliveryFlow
{
    public function DefaultDeliveryFlow(router:Router)
    {
        super();

        this.router = router;
    }

    private var router:Router;

    private var message:Message;
    private var token:Token;

    private var isCanceled:Boolean = false;

    public function send(message:Message):Token
    {
        this.message = message;
        this.token = new Token();
//        this.token.addResponder(new CancelResponder(
//            function(info:Object):void
//            {
//                cancel();
//            })
//        )

        if (message.recipient.online)
        {
            sendMessage(message);
        }
        else
        {
            updatePeerId();
        }

        return token;
    }

    public function cancel():void
    {
        isCanceled = true;

        router.cancel(message);
    }

    private var isPeerIdUpdated:Boolean = false;

    private function tryAgain():void
    {
        if (isPeerIdUpdated)
        {
            token.applyFault({})
        }
        else
        {
            updatePeerId();
        }
    }

    private function updatePeerId():void
    {
        isPeerIdUpdated = true;

        Account.account.getPeerId(message.recipient, new Responder(function(data:Object):void
           {
               message.recipient.peerId = data as String;

               sendMessage(message);
           },
           function(info:Object):void
           {
               token.applyFault(info);
           })
        )
    }

    private function sendMessage(message:Message):void
    {
        if (isCanceled)
        {
            token.applyFault(Fault.createCancelFault());
        }
        else
        {
            var t:Token = router.send(message);
            t.addResponder(new Responder(
                function(data:Object):void
                {
                    token.applyResult(data);
                },
                function(info:Object):void
                {
                    tryAgain();
                })
            )
        }

    }
}
}
