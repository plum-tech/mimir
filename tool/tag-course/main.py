from typing import List, Dict

course_file = open('COURSE.txt', encoding='utf-8').readlines()
course_list = [x.strip() for x in course_file]


mapping_file: List[str] = open('MAPPING.txt', encoding='utf-8').readlines()
mapping = {}

for line in mapping_file:
    cows = line.split()
    title = cows[0]
    items = cows[1:]
    for item in items:
        mapping[item] = title


def tag_course(course: str) -> str or None:
    for k, v in mapping.items():
        if k in course:
            return v
    return None


def select_course(tagged: bool, count: int = 0) -> List[str]:
    if count == 0:
        count = len(course_list)

    i: int = 0
    result: List[str] = []
    while i < len(course_list) and count > 0:
        if (tag_course(course_list[i]) != None) == tagged:
            count -= 1
            result.append(course_list[i])
        i += 1

    return result


def add_tag(tag: str, category: str):
    mapping[tag] = category

def write_all(fp):
    # 把 mapping 倒排
    result: Dict[str, List[str]] = {}
    for k, v in mapping.items():
        if v in result:
            result[v].append(k)
        else:
            result[v] = [k]

    for k, l in result.items():
        fp.write(f'{k} {" ".join(l)}\n')


if __name__ == '__main__':

    while True:
        r = select_course(False, 10)
        t = select_course(False)
        print(f'当前前10个未标记的课程名称 剩余（{len(t)}）')
        print(r)

        print('分类代码')
        s = set(mapping.values())
        codes = dict(zip(range(0, len(s)), sorted(s)))
        print(codes)
        text = input('标签 分类代码:')
        if text == 'q':
            break
        k, v = tuple(text.split())
        try:
            v = codes[int(v)]
        except:
            pass

        add_tag(k, v)
        print('\n')
    
    fp = open('output.txt', 'w+', encoding='utf-8')
    write_all(fp)
    fp.close()
