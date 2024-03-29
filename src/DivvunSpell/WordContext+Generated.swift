// automatically generated by the FlatBuffers compiler, do not modify
// swiftlint:disable all
// swiftformat:disable all

public struct IndexedWord: FlatBufferObject, Verifiable {

  static func validateVersion() { FlatBuffersVersion_2_0_0() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Table

  public static func getRootAsIndexedWord(bb: ByteBuffer) -> IndexedWord { return IndexedWord(Table(bb: bb, position: Int32(bb.read(def: UOffset.self, position: bb.reader)) + Int32(bb.reader))) }

  private init(_ t: Table) { _accessor = t }
  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Table(bb: bb, position: o) }

  private enum VTOFFSET: VOffset {
    case index = 4
    case value = 6
    var v: Int32 { Int32(self.rawValue) }
    var p: VOffset { self.rawValue }
  }

  public var index: UInt64 { let o = _accessor.offset(VTOFFSET.index.v); return o == 0 ? 0 : _accessor.readBuffer(of: UInt64.self, at: o) }
  public var value: String? { let o = _accessor.offset(VTOFFSET.value.v); return o == 0 ? nil : _accessor.string(at: o) }
  public var valueSegmentArray: [UInt8]? { return _accessor.getVector(at: VTOFFSET.value.v) }
  public static func startIndexedWord(_ fbb: inout FlatBufferBuilder) -> UOffset { fbb.startTable(with: 2) }
  public static func add(index: UInt64, _ fbb: inout FlatBufferBuilder) { fbb.add(element: index, def: 0, at: VTOFFSET.index.p) }
  public static func add(value: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: value, at: VTOFFSET.value.p) }
  public static func endIndexedWord(_ fbb: inout FlatBufferBuilder, start: UOffset) -> Offset { let end = Offset(offset: fbb.endTable(at: start)); return end }
  public static func createIndexedWord(
    _ fbb: inout FlatBufferBuilder,
    index: UInt64 = 0,
    valueOffset value: Offset = Offset()
  ) -> Offset {
    let __start = IndexedWord.startIndexedWord(&fbb)
    IndexedWord.add(index: index, &fbb)
    IndexedWord.add(value: value, &fbb)
    return IndexedWord.endIndexedWord(&fbb, start: __start)
  }

  public static func verify<T>(_ verifier: inout Verifier, at position: Int, of type: T.Type) throws where T: Verifiable {
    var _v = try verifier.visitTable(at: position)
    try _v.visit(field: VTOFFSET.index.p, fieldName: "index", required: false, type: UInt64.self)
    try _v.visit(field: VTOFFSET.value.p, fieldName: "value", required: false, type: ForwardOffset<String>.self)
    _v.finish()
  }
}

public struct WordContext: FlatBufferObject, Verifiable {

  static func validateVersion() { FlatBuffersVersion_2_0_0() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Table

  public static func getRootAsWordContext(bb: ByteBuffer) -> WordContext { return WordContext(Table(bb: bb, position: Int32(bb.read(def: UOffset.self, position: bb.reader)) + Int32(bb.reader))) }

  private init(_ t: Table) { _accessor = t }
  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Table(bb: bb, position: o) }

  private enum VTOFFSET: VOffset {
    case current = 4
    case firstBefore = 6
    case secondBefore = 8
    case firstAfter = 10
    case secondAfter = 12
    var v: Int32 { Int32(self.rawValue) }
    var p: VOffset { self.rawValue }
  }

  public var current: IndexedWord? { let o = _accessor.offset(VTOFFSET.current.v); return o == 0 ? nil : IndexedWord(_accessor.bb, o: _accessor.indirect(o + _accessor.postion)) }
  public var firstBefore: IndexedWord? { let o = _accessor.offset(VTOFFSET.firstBefore.v); return o == 0 ? nil : IndexedWord(_accessor.bb, o: _accessor.indirect(o + _accessor.postion)) }
  public var secondBefore: IndexedWord? { let o = _accessor.offset(VTOFFSET.secondBefore.v); return o == 0 ? nil : IndexedWord(_accessor.bb, o: _accessor.indirect(o + _accessor.postion)) }
  public var firstAfter: IndexedWord? { let o = _accessor.offset(VTOFFSET.firstAfter.v); return o == 0 ? nil : IndexedWord(_accessor.bb, o: _accessor.indirect(o + _accessor.postion)) }
  public var secondAfter: IndexedWord? { let o = _accessor.offset(VTOFFSET.secondAfter.v); return o == 0 ? nil : IndexedWord(_accessor.bb, o: _accessor.indirect(o + _accessor.postion)) }
  public static func startWordContext(_ fbb: inout FlatBufferBuilder) -> UOffset { fbb.startTable(with: 5) }
  public static func add(current: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: current, at: VTOFFSET.current.p) }
  public static func add(firstBefore: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: firstBefore, at: VTOFFSET.firstBefore.p) }
  public static func add(secondBefore: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: secondBefore, at: VTOFFSET.secondBefore.p) }
  public static func add(firstAfter: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: firstAfter, at: VTOFFSET.firstAfter.p) }
  public static func add(secondAfter: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: secondAfter, at: VTOFFSET.secondAfter.p) }
  public static func endWordContext(_ fbb: inout FlatBufferBuilder, start: UOffset) -> Offset { let end = Offset(offset: fbb.endTable(at: start)); return end }
  public static func createWordContext(
    _ fbb: inout FlatBufferBuilder,
    currentOffset current: Offset = Offset(),
    firstBeforeOffset firstBefore: Offset = Offset(),
    secondBeforeOffset secondBefore: Offset = Offset(),
    firstAfterOffset firstAfter: Offset = Offset(),
    secondAfterOffset secondAfter: Offset = Offset()
  ) -> Offset {
    let __start = WordContext.startWordContext(&fbb)
    WordContext.add(current: current, &fbb)
    WordContext.add(firstBefore: firstBefore, &fbb)
    WordContext.add(secondBefore: secondBefore, &fbb)
    WordContext.add(firstAfter: firstAfter, &fbb)
    WordContext.add(secondAfter: secondAfter, &fbb)
    return WordContext.endWordContext(&fbb, start: __start)
  }

  public static func verify<T>(_ verifier: inout Verifier, at position: Int, of type: T.Type) throws where T: Verifiable {
    var _v = try verifier.visitTable(at: position)
    try _v.visit(field: VTOFFSET.current.p, fieldName: "current", required: false, type: ForwardOffset<IndexedWord>.self)
    try _v.visit(field: VTOFFSET.firstBefore.p, fieldName: "firstBefore", required: false, type: ForwardOffset<IndexedWord>.self)
    try _v.visit(field: VTOFFSET.secondBefore.p, fieldName: "secondBefore", required: false, type: ForwardOffset<IndexedWord>.self)
    try _v.visit(field: VTOFFSET.firstAfter.p, fieldName: "firstAfter", required: false, type: ForwardOffset<IndexedWord>.self)
    try _v.visit(field: VTOFFSET.secondAfter.p, fieldName: "secondAfter", required: false, type: ForwardOffset<IndexedWord>.self)
    _v.finish()
  }
}

