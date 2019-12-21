/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 10:20 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.routing.impl
{
import pipes.core.channel.Channel;
import pipes.core.config.PipeContext;
import pipes.core.routing.MessageAgent;
import pipes.core.routing.Router;
import pipes.domain.Message;
import pipes.domain.Responder;
import pipes.domain.Sendable;
import pipes.domain.Token;

/**
 * Default Router implementation.
 */
public class DefaultRouter implements Router
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function DefaultRouter()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var channel:Channel;

    private var agents:Object = {};

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function init(info:PipeContext):void
    {
        channel = info.channel;
    }

    public function send(message:Sendable):Token
    {
        if (message is Message)
        {
            return sendMessage(message as Message);
        }
        else
        {
            channel.send(message);

            return null;
        }
    }

    private function sendMessage(message:Message):Token
    {
        var agent:MessageAgent = new MessageAgent(channel);

        agents[message.objectId] = agent;

        var token:Token = agent.send(message);
        token.addResponder(new Responder(
                function (data:Object):void
                {
                    removeAgent(message);
                },
                function (info:Object):void
                {
                    removeAgent(message);
                })
        );

        return token;
    }

    public function cancel(message:Sendable):void
    {
        var agent:MessageAgent = agents[message.objectId];

        if (agent)
            agent.cancel();
    }

    private function removeAgent(message:Sendable):void
    {
        agents[message.objectId] = null;
        delete agents[message.objectId];
    }
}
}

import pipes.core.routing.impl.DefaultRouter;
import pipes.domain.Message;
import pipes.domain.Responder;

class MessageResponder extends Responder
{
    public function MessageResponder(router:DefaultRouter, message:Message)
    {
        super(null, null);

        this.router = router;
        this.message = message;
    }

    private var router:DefaultRouter;
    private var message:Message;

    override public function result(data:Object):void
    {
        // remove agent
    }

    override public function fault(info:Object):void
    {
        // remove agent
    }
}
