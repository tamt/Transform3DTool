package transform3d.consts 
{
	/**
	 * ...
	 * @author tamt
	 */
	public class TransformToolMode
	{
		public static const ALL:String = "all";
		public static const ROTATION:String = "rotation";
		public static const TRANSLATION:String = "translation";
		
		public static function isInvalidMode(mode:String):Boolean {
			return !(mode == ALL || mode == ROTATION || mode == TRANSLATION);
		}
		
	}

}