/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 12:38 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.config
{
import pipes.core.channel.Channel;
import pipes.core.connection.Connection;
import pipes.core.routing.Router;
import pipes.core.session.Session;
import pipes.service.MessagingService;

public class PipeContext
{
    public function PipeContext(name:String)
    {
        super();

        _name = name;
    }

    private var _name:String;

    public function get name():String
    {
        return _name;
    }

    public function get connection():Connection
    {
        return Connection.connection;
    }

    private var _session:Session;

    public function get session():Session
    {
        if (_session == null)
        {
            _session = new ConfigDefaults.session();
            _session.init(this);
        }

        return _session;
    }

    private var _channel:Channel;

    public function get channel():Channel
    {
        if (_channel == null)
        {
            _channel = new ConfigDefaults.channel();
            Object(_channel).init(this);
        }

        return _channel;
    }

    private var _router:Router;

    public function get router():Router
    {
        if (_router == null)
        {
            _router = new ConfigDefaults.router();
            Object(_router).init(this);
        }

        return _router;
    }

    // Services

    private var _messaging:MessagingService;

    public function get messaging():MessagingService
    {
        if (_messaging == null)
        {
            _messaging = new ConfigDefaults.messaging();
            Object(_messaging).init(this);
        }

        return _messaging;
    }

    public function activate():void
    {
        connection.activate();
        session.activate();
    }

    public function deactivate():void
    {
        connection.deactivate();
        session.deactivate();
    }
}
}
