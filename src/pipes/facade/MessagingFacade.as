/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 12:48 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.facade
{
import pipes.core.config.PipeContext;
import pipes.core.service.Account;
import pipes.domain.Fault;
import pipes.domain.Message;
import pipes.domain.Result;
import pipes.domain.Subscription;
import pipes.domain.Token;
import pipes.domain.User;
import pipes.service.messaging.Delivery;
import pipes.service.messaging.Delivery;
import pipes.service.MessagingService;
import pipes.service.messaging.impl.GenericMessageHandler;

/**
 * Facade for messaging functionality.
 *
 * <p>The MessagingFacade represents high-level messaging functionality, it
 * provides methods for:
 *
 * <ul>
 *     <li>sending message to remote User with guaranteed delivery;</li>
 *     <li>adding subscription to handle incoming messages;</li>
 * </ul>
 */
public class MessagingFacade implements Facade
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function MessagingFacade()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var messaging:MessagingService;

    private var subscription:Subscription;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function init(info:PipeContext):void
    {
        messaging = info.messaging;

        messaging.addHandler(new GenericMessageHandler(Message, messageHandler));
    }

    public function send(member:User, message:Object):Delivery
    {
        var msg:Message = new Message();
        msg.sender = Account.account.current;
        msg.recipient = member;
        msg.body = message;

        return messaging.sendMessage(msg) as Delivery;
    }

    public function subscribe(subscription:Subscription):void
    {
        this.subscription = subscription;
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function messageHandler(message:Message):void
    {
        try
        {
            var data:Object = this.subscription.receive(message);

            var result:Result = new Result();
            result.correlationId = message.objectId;
            result.recipient = message.sender;
            result.sender = Account.account.current;
            result.data = data;

            messaging.sendResponse(result);
        }
        catch (error:Error)
        {
            var fault:Fault = new Fault();
            fault.correlationId = message.objectId;
            fault.recipient = message.sender;
            fault.sender = Account.account.current;
            fault.message = error.getStackTrace();

            messaging.sendResponse(result);
        }
    }
}
}
