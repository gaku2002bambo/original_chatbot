import json, pathlib

src = pathlib.Path("persona_1.jsonl")
dst = pathlib.Path("data/train.jsonl")
dst.parent.mkdir(exist_ok=True)
with src.open(encoding="utf-8") as fr, dst.open("w", encoding="utf-8") as fw:
    for line in fr:
        data = json.loads(line)
        # instruction はそのまま、response → output にリネーム
        new = {"prompt": data["instruction"], "completion": data["response"]}
        fw.write(json.dumps(new, ensure_ascii=False) + "\n")
# 同じ内容を valid/test にもコピー
for split in ("valid", "test"):
    (dst.parent / f"{split}.jsonl").write_text(dst.read_text(), encoding="utf-8")
