/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 1:09 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.service.messaging.impl
{
import pipes.service.messaging.*;
import pipes.domain.Message;

public class GenericMessageHandler implements MessageHandler
{
    public function GenericMessageHandler(type:Class, handler:Function)
    {
        super();

        this.type = type;
        this.handler = handler;
    }

    private var type:Class;
    private var handler:Function;

    public function known(message:Message):Boolean
    {
        return message is type;
    }

    public function handle(message:Message):void
    {
        handler(message);
    }
}
}
