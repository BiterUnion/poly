import numpy as np
import regex

num_runs = 20
# data_size = 10
data_size = 50
# data_size = 1000
num_evaluations = 1000000

averages = dict()

for variant in ['overhead', 'inlined', 'explicit', 'implicit', 'wrapped', 'poly', 'derived']:
    runtimes = []
    with open(f'{variant}_{data_size}_{num_evaluations}') as runtimes_file:
        for line in runtimes_file:
            match = regex.fullmatch(r'Duration: (\d+\.\d+)ms\n', line)
            runtimes.append(float(match.group(1)))
    min = np.min(runtimes)
    avg = np.average(runtimes)
    max = np.max(runtimes)
    averages[variant] = avg

    slowdown_base = None
    if variant in ['explicit', 'implicit', 'poly', 'derived']:
        slowdown_base = 'inlined'
    elif variant in ['wrapped']:
        slowdown_base = 'explicit'
    slowdown = ''
    if slowdown_base is not None:
        slowdown = ((avg - averages['overhead']) / (averages[slowdown_base] - averages['overhead']) - 1) * 100
        slowdown = f' ({"+" if slowdown > 0 else ""}{slowdown:.3}% over {slowdown_base} without overhead)'
    print(f'{variant:8}: {min:12.7}ms {avg:12.7}ms {max:12.7}ms{slowdown}')
