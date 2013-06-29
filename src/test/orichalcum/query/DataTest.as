package orichalcum.query  
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.strictlyEqualTo;
	
	public class DataTest 
	{
		private var $subject:OrichalcumQuery;
		
		[Before]
		public function setup():void
		{
			$subject = $(new Sprite)
		}
		
		[After]
		public function teardown():void
		{
			$subject = null;
		}
		
		[Test]
		public function setAndGetDatum():void
		{
			assertThat($subject.data('name', 'value').data('name'), equalTo('value'));
		}
		
		[Test]
		public function setAndGetData():void
		{
			assertThat($subject.data({name:'value'}).data().name, equalTo('value'));
		}
		
		[Test]
		public function clearData():void
		{
			assertThat($subject.data({a:'a'}).data({}).a, equalTo(undefined));
		}
		
		[Test]
		public function setAndGetDataIsUnique():void
		{
			const setData:Object = {};
			assertThat($subject.data(setData).data(), not(strictlyEqualTo(setData)));
		}
		
		[Test]
		public function setsEachContentsData():void
		{
			const data:Object = {name:'value'};
			const first:DisplayObject = new Sprite;
			const second:DisplayObject = new Sprite;
			const $both:OrichalcumQuery = $([first, second]);
			$both.data(data);
			assertThat($(first).data('name'), equalTo('value'));
			assertThat($(second).data('name'), equalTo('value'));
		}
		
		[Test]
		public function getsFirstContentsData():void
		{
			const firstData:Object = {a:'a'};
			const secondData:Object = {b:'b'};
			const first:DisplayObject = new Sprite;
			const second:DisplayObject = new Sprite;
			const $both:OrichalcumQuery = $([first, second]);
			$(first).data(firstData);
			$(second).data(secondData);
			assertThat($(first).data(), hasProperties(firstData));
			assertThat($(second).data(), hasProperties(secondData));
			assertThat($both.data(), hasProperties(firstData));
			assertThat($both.data(), not(hasProperties(secondData)));
		}
		
	}

}