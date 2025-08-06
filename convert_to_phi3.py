#!/usr/bin/env python
# convert_to_phi3.py
import json, sys

def phi3_format(inst: str, resp: str) -> str:
    # ChatML（Phi-3）テンプレート
    return f"<|user|>{inst.strip()}<|end|>\n<|assistant|>{resp.strip()}<|end|>"

in_path  = sys.argv[1]          # 元: instruction/response.jsonl
out_path = sys.argv[2]          # 先: phi3_train.jsonl

with open(in_path, encoding="utf-8") as fin, \
     open(out_path, "w", encoding="utf-8") as fout:
    for line in fin:
        obj = json.loads(line)
        merged = phi3_format(obj["instruction"], obj["response"])
        fout.write(json.dumps({"text": merged}, ensure_ascii=False) + "\n")