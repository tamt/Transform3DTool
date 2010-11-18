package cn.itamt.transform3d 
{
	import cn.itamt.transform3d.controls.Control;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class Transform3DTool extends Sprite
	{
		
		private var _rTool:RotationTool;
		private var _tTool:TranslationTool;
		
		public function Transform3DTool() 
		{
			_rTool = new RotationTool();
			addChild(_rTool);
			
			_tTool = new TranslationTool();
			addChild(_tTool);
		}
		
	}

}