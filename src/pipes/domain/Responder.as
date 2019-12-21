/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 12:13 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.domain
{
public class Responder
{
    public function Responder(result:Function, error:Function)
    {
        super();

        this.resultHandler = result;
        this.errorHandler = error;
    }

    private var resultHandler:Function;
    private var errorHandler:Function;

    public function result(data:Object):void
    {
        if (this.resultHandler != null)
            this.resultHandler(data);
    }

    public function fault(info:Object):void
    {
        if (this.errorHandler != null)
            this.errorHandler(info);
    }
}
}
