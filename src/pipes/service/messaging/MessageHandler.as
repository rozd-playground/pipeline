/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 11:50 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.service.messaging
{
import pipes.domain.Message;

public interface MessageHandler
{
    function known(message:Message):Boolean;

    function handle(message:Message):void;
}
}
