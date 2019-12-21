/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 5/27/13
 * Time: 12:40 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.utils
{
public class DelayedCall
{
    public function DelayedCall(method:Function, params:Array)
    {
        super();

        this.method = method;
        this.params = params;
    }

    private var method:Function;

    private var params:Array;

    public function equalTo(that:DelayedCall):Boolean
    {
        if (this.method != that.method)
            return false;

        // params equal, both are null e.g.
        if (this.params == that.params)
            return true;

        // one is null when another is bot
        if (!this.params || !that.params)
            return false;

        // both aren't null and have different length
        if (this.params.length != that.params.length)
            return false;

        for (var i:int = 0, n:int = this.params.length; i < n; i++)
        {
            if (this.params[i] != that.params[i])
                return false;
        }

        return true;
    }

    public function invoke():void
    {
        method.apply(null, params);
    }
}
}
