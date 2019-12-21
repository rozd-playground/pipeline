/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 6:41 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.domain
{
public class CancelResponder
{
    public function CancelResponder(cancel:Function)
    {
        super();

        this.cancelHandler = cancel;
    }

    private var cancelHandler:Function;

    public function cancel(info:Object):void
    {
        if (this.cancelHandler != null)
            this.cancelHandler(info);
    }
}
}
