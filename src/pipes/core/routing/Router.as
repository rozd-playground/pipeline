/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 10:01 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.routing
{
import pipes.domain.Sendable;
import pipes.domain.Token;

/**
 * Responsible for sending message trough p2p connection. It don't guarantee
 * message delivery.
 *
 */
public interface Router
{
    function send(message:Sendable):Token;

    function cancel(message:Sendable):void;
}
}
