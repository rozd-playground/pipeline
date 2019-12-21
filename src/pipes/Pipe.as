/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 12:29 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes
{
import pipes.core.config.PipeContext;
import pipes.domain.Subscription;
import pipes.domain.Token;
import pipes.domain.User;
import pipes.facade.ContactsFacade;
import pipes.facade.MessagingFacade;

public class Pipe
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Pipe(info:PipeContext)
    {
        super();

        this.info = info;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var info:PipeContext;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //------------------------------------
    //  messaging
    //------------------------------------

    private var _messaging:MessagingFacade;

    private function get messaging():MessagingFacade
    {
        if (_messaging == null)
        {
            _messaging = new MessagingFacade();
            _messaging.init(info);
        }

        return _messaging;
    }

    //------------------------------------
    //  contacts
    //------------------------------------

    private var _contacts:ContactsFacade;

    public function get contacts():ContactsFacade
    {
        if (_contacts == null)
        {
            _contacts = new ContactsFacade();
            Object(_contacts).init(info);
        }

        return _contacts;
    }

    //--------------------------------------------------------------------------
    //
    //  Getter/Setter
    //
    //--------------------------------------------------------------------------

    public function getContext():PipeContext
    {
        return info;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //-----------------------------------
    //  Methods: messaging
    //-----------------------------------

    public function send(member:User, message:Object):Token
    {
        return messaging.send(member, message);
    }

    public function subscribe(subscription:Subscription):void
    {
        messaging.subscribe(subscription);
    }

    //-----------------------------------
    //  Methods: contacts
    //-----------------------------------

    public function getContactList():Array
    {
        return contacts.getContactList();
    }
}
}
