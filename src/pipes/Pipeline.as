/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 11:58 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes
{
import pipes.core.connection.Connection;

public class Pipeline
{
    private static var _pipes:Pipes

    public static function get pipes():Pipes
    {
        if (_pipes == null)
        {
            _pipes = new Pipes();
        }

        return _pipes;
    }

    public static function init(server:String):void
    {
        Connection.prepare(server);
    }

    public function Pipeline()
    {
    }
}
}
