/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/20/13
 * Time: 11:32 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes.domain
{
/**
 * The Fault class represents a some error that occurs during message send.
 */
public class Fault extends SendableBase implements Response
{
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /** Creates new Fault object. */
    public static function create(code:uint, message:String):Fault
    {
        var fault:Fault = new Fault();
        fault._code = code;
        fault._message = message;

        return fault;
    }

    /** Creates cancellation Fault. */
    public static function createCancelFault(message:String=null):Fault
    {
        return create(FaultCode.CANCELED, message);
    }

    /** Creates timeout Fault */
    public static function createTimeoutFault(message:String=null):Fault
    {
        return create(FaultCode.TIMEOUT, message);
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /** Constructor */
    public function Fault()
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
    //  code
    //----------------------------------

    private var _code:uint;

    public function get code():uint
    {
        return _code;
    }

    public function set code(value:uint):void
    {
        _code = value;
    }

    //----------------------------------
    //  message
    //----------------------------------

    private var _message:String;

    public function get message():String
    {
        return _message;
    }

    public function set message(value:String):void
    {
        _message = value;
    }
}
}
