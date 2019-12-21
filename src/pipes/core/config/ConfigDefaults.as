/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 12:05 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.config
{
import pipes.core.channel.impl.DirectRoutingChannel;
import pipes.core.remoting.impl.DefaultRemoting;
import pipes.core.routing.impl.DefaultRouter;
import pipes.core.session.Session;
import pipes.service.messaging.impl.DefaultMessageService;

public class ConfigDefaults
{
    public static var remoting:Class = DefaultRemoting;

    public static var session:Class = Session;

    public static var channel:Class = DirectRoutingChannel;

    public static var messaging:Class = DefaultMessageService;

    public static var router:Class = DefaultRouter;

    public function ConfigDefaults()
    {
    }
}
}
