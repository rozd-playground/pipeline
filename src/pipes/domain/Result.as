/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 11:30 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.domain
{

/**
 * The Result class represents a successful response to message from destination
 * Peer.
 */
public class Result extends SendableBase implements Response
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /** Constructor */
    public function Result():void
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  correlationId
    //----------------------------------

    private var _correlationId:String;

    public function get correlationId():String
    {
        return _correlationId;
    }

    public function set correlationId(value:String):void
    {
        _correlationId = value;
    }
    //----------------------------------
    //  data
    //----------------------------------

    private var _data:Object;

    public function get data():Object
    {
        return _data;
    }

    public function set data(value:Object):void
    {
        _data = value;
    }
}
}
