package orichalcum.query
{
	public function $(arg:* = null):OrichalcumQuery
	{
		return new OrichalcumQuery(arg);
	}
}
