(*For the two mode types, selectable and then randomly generated*)
type phylum = Zou | Yu | Lin | Chong | Esoteric | Sovereign

type ancestry =
    | Human
    | Hybrid of phylum * string
    | Sovereign_Flesh of string

