/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 10:11 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.service.messaging.impl
{
import flash.net.registerClassAlias;

import pipes.core.channel.Channel;
import pipes.core.config.PipeContext;
import pipes.core.events.ChannelEvent;
import pipes.core.routing.Router;
import pipes.domain.Fault;
import pipes.domain.Message;
import pipes.domain.Response;
import pipes.domain.Result;
import pipes.domain.Token;
import pipes.domain.User;
import pipes.service.MessagingService;
import pipes.service.messaging.MessageHandler;

public class DefaultMessageService implements MessagingService
{
    {
        registerClassAlias("p2p.Message", Message);
        registerClassAlias("p2p.Fault", Fault);
        registerClassAlias("p2p.Result", Result);
        registerClassAlias("p2p.Member", User);
    }

    public function DefaultMessageService()
    {
    }

    private var router:Router;
    private var channel:Channel;

    private var handlers:Array = [];

    public function init(info:PipeContext):void
    {
        router = info.router;
        channel = info.channel;

        channel.addEventListener(ChannelEvent.MESSAGE_RECEIVED, messageReceivedHandler);
    }

    public function sendMessage(message:Message):Token
    {
        message.objectId = "msg:" + message.sender.userId + "->" + message.recipient.userId + "|" + new Date().time;

        var flow:DeliveryFlowImpl = new DeliveryFlowImpl(router);

        return flow.send(message);
    }

    public function sendResponse(response:Response):void
    {
        response.objectId = "res:" + response.sender.userId + "->" + response.recipient.userId + "|" + new Date().time;

        router.send(response);
    }

    public function addHandler(handler:MessageHandler):void
    {
        handlers.push(handler);
    }

    private function messageReceivedHandler(event:ChannelEvent):void
    {
        if (event.data is Message)
        {
            var message:Message = event.data as Message;

            for each (var handler:MessageHandler in handlers)
            {
                if (handler.known(message))
                    handler.handle(message);
            }
        }
    }
}
}
