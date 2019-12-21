/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 12:31 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.service.messaging
{
import pipes.domain.Message;
import pipes.domain.Token;

/**
 * Represents message flow that it passes to reach destination. DeliveryFlow
 * takes into account server-side part of Pipeline thereby it can guarantee
 * message delivering if destination peer is online.
 */
public interface DeliveryFlow
{
    function send(message:Message):Token;
}
}
