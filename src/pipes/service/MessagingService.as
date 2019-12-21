/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 12:48 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.service
{
import pipes.domain.Message;
import pipes.domain.Response;
import pipes.domain.Token;
import pipes.service.messaging.MessageHandler;

/**
 * Responsible for messaging in Pipe.
 *
 * <p>The MessagingService takes into account p2p nature of Pipe and its backend
 * (Pipeline Application Server). Thereby it can guarantee message delivery, in
 * case if destination peer is online. This is done thorough MessageFlow
 * implementations</p>
 */
public interface MessagingService
{
    function sendMessage(message:Message):Token;

    function sendResponse(response:Response):void;

    function addHandler(handler:MessageHandler):void;
}
}

