package transform3d.consts
{
	/**
	 * transorm mode.
	 * @author tamt
	 */
	public class Transform3DMode
	{
		public static const INTERNAL:uint = 1;
		public static const GLOBAL:uint = 2;
		
		public static function toString(mode:uint):String {
			switch(mode) {
				case 1:
					return "internal";
					break;
				case 2:
					return "global";
					break;
			}
			
			return "internal";
		}
		
		public static function isInvalidMode(mode:uint):Boolean {
			return mode != INTERNAL && mode != GLOBAL;
		}
	}

}