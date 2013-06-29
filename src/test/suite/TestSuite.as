package suite
{
	import orichalcum.query.ArgumentTest;
	import orichalcum.query.ChildrenTest;
	import orichalcum.query.ClosestTest;
	import orichalcum.query.DataTest;
	import orichalcum.query.EqTest;
	import orichalcum.query.FilterTest;
	import orichalcum.query.FindTest;
	import orichalcum.query.FirstTest;
	import orichalcum.query.IndexTest;
	import orichalcum.query.LastTest;
	import orichalcum.query.NextAllTest;
	import orichalcum.query.NextTest;
	import orichalcum.query.NextUntilTest;
	import orichalcum.query.NotTest;
	import orichalcum.query.OffTest;
	import orichalcum.query.OnTest;
	import orichalcum.query.PrevAllTest;
	import orichalcum.query.PrevTest;
	import orichalcum.query.PrevUntilTest;
	import orichalcum.query.RemoveDataTest;
	import orichalcum.query.SiblingsTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite
	{
		// ! need append,prepend,appendTo,prependTo
		
		public var argumentTest:ArgumentTest;
		
		// filtering
		
		public var filterTest:FilterTest;
		public var notTest:NotTest;
		public var firstTest:FirstTest;
		public var lastTest:LastTest;
		public var eqTest:EqTest;
		public var indexTest:IndexTest;
		
		// Traversal
		
		public var childrenTest:ChildrenTest;
		public var findTest:FindTest;
		public var closestTest:ClosestTest;
		public var nextTest:NextTest;
		public var nextAllTest:NextAllTest;
		public var nextUntilTest:NextUntilTest;
		public var prevTest:PrevTest;
		public var prevAllTest:PrevAllTest;
		public var prevUntilTest:PrevUntilTest;
		public var siblingsTest:SiblingsTest;
		
		// Data
		
		public var dataTest:DataTest;
		public var removeDataTest:RemoveDataTest;
		
		// Event
		
		// unbind
		public var onTest:OnTest;
		public var offTest:OffTest;
		
		// manipulate
		//public var emptyTest:EmptyTest;
		
	}

}
