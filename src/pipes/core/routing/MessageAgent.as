/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 10:31 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.routing
{
import flash.events.TimerEvent;
import flash.utils.Timer;

import pipes.core.channel.Channel;
import pipes.core.events.ChannelEvent;
import pipes.core.utils.DelayUtil;
import pipes.domain.Fault;
import pipes.domain.Message;
import pipes.domain.Response;
import pipes.domain.Result;
import pipes.domain.Sendable;
import pipes.domain.Token;

/**
 * Responsible for sending message through Channel and tracking it status. The
 * message sending could have four outcomes:
 * <ul>
 *     <li><b>result</b> - when message delivered and successfully handled;</li>
 *     <li><b>fault</b> - when message has been delivered, but error occurred on that side;</li>
 *     <li><b>timeout</b> - when message can not be delivered in specified timeout;</li>
 *     <li><b>canceled</b> - when message has been canceled on this side.</li>
 * </ul>
 */
public class MessageAgent
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function MessageAgent(channel:Channel)
    {
        super();

        this.channel = channel;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var channel:Channel;

    private var message:Message;

    private var timer:Timer;

    private var token:Token;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Sends message through specified Channel.
     *
     * @param message Message to send
     *
     * @return Token to control message delivery
     */
    public function send(message:Message):Token
    {
        this.message = message;

        this.token = new Token();

        if (channel.activate)
        {
            doSend();
        }
        else
        {
            DelayUtil.delayToEvent(channel, ChannelEvent.CHANNEL_ACTIVATE, this.doSend);
        }

        return this.token;
    }

    /** @private */
    private function doSend():void
    {
        startTimer();

        channel.addEventListener(ChannelEvent.MESSAGE_RECEIVED, messageReceivedHandler);

        channel.send(message);
    }

    /** Cancels current message sending. */
    public function cancel():void
    {
        token.applyFault(Fault.createCancelFault());

        dispose();
    }

    /** Cleanups agent whereupon it will be ready for next use. */
    public function dispose():void
    {
        channel.removeEventListener(ChannelEvent.MESSAGE_RECEIVED, messageReceivedHandler);

        stopTimer();

        this.message = null;
        this.token = null;
    }

    //-----------------------------------
    //  Methods: timer
    //-----------------------------------

    private function startTimer():void
    {
        if (timer == null)
        {
            timer = new Timer(5000, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
            timer.start();
        }
    }

    private function stopTimer():void
    {
        if (timer != null)
        {
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
            timer.stop();
            timer = null;
        }
    }

    //-----------------------------------
    //  Methods: handlers
    //-----------------------------------

    private function handleResult(result:Result):void
    {
        token.applyResult(result);

        dispose();
    }

    private function handleFault(fault:Fault):void
    {
        token.applyFault(fault);

        dispose();
    }

    private function handleTimeout():void
    {
        token.applyFault(Fault.createTimeoutFault());

        dispose();
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function messageReceivedHandler(event:ChannelEvent):void
    {
        var response:Response = event.data as Response;

        if (response && response.correlationId == message.objectId)
        {
            if (response is Result)
            {
                handleResult(Result(response));
            }
            else if (response is Fault)
            {
                handleFault(Fault(response));
            }
        }
    }

    private function timerCompleteHandler(event:TimerEvent):void
    {
        handleTimeout();
    }

}
}
