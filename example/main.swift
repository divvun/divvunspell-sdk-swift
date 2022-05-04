func main() {
    let moo = try! SpellerArchive.open(path: "/Users/brendan/Downloads/se.bhfst")
    print(try! moo.speller().suggest(word: "same"))
}

main()
