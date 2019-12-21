/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 11:04 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.domain
{
public interface Response extends Sendable
{
    function get correlationId():String;
    function set correlationId(value:String):void;
}
}
