/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 1:12 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.facade
{
import pipes.core.config.PipeContext;
import pipes.core.service.Account;
import pipes.domain.Responder;

public class ContactsFacade implements Facade
{
    public function ContactsFacade()
    {
    }

    public function init(info:PipeContext):void
    {
        refreshContactList(null);
    }

    private var contacts:Array;

    public function getContactList():Array
    {
        if (contacts == null)
        {
            refreshContactList(null)
        }

        return contacts;
    }

    public function refreshContactList(responder:Responder):void
    {
        Account.account.getContactList(new Responder(function(data:Object):void
            {
                contacts = data as Array;

                if (responder)
                    responder.result(data);
            },
            function(info:Object):void
            {
                if (responder)
                    responder.fault(info);
            })
        );
    }
}
}
