/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 10:56 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.channel
{
import flash.events.IEventDispatcher;
import flash.net.NetGroup;

import pipes.domain.Sendable;

[Event(name="messageReceived", type="pipes.core.events.ChannelEvent")]
[Event(name="channelActivate", type="pipes.core.events.ChannelEvent")]

/**
 * Responsible for transport layer for messaging functionality.
 */
public interface Channel extends IEventDispatcher
{
    function get activate():Boolean;

    function dispose():void;

    function send(message:Sendable):void;
}
}
