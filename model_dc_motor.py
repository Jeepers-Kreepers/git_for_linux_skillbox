import sympy                                        # Импортирует библиотеку SymPy для символьных вычислений.
from sympy.plotting import plot                     # Импортирует функцию plot для построения графиков.

U = sympy.symbols('U')                              # Определяет символ U (напряжение).
T_m = sympy.symbols('T_m')                          # Определяет символ T_m (Константа / Постоянная времени).
t = sympy.symbols('t')                              # Определяет символ t (время).
k_e = sympy.symbols('k_e', positive=True)    # Опр k_e > 0 коэффициент обратной ЭДС
omega = sympy.Function('omega')                     # Определяет функцию omega(t) - угловая скорость rad/s

ode = sympy.Eq(omega(t).diff(t),
               U/(k_e*T_m) - omega(t)/T_m)          # Определяет уравнение для угловой скорости

# решение уравнения (определение изменения угловой скорости dc двигателя)
ode_sol = sympy.dsolve(ode, omega(t), ics={omega(0): 0})    # Решает уравнение исходя из начальных условий
ode_num = ode_sol.subs({U: 8, T_m: 0.08, k_e: 0.5})         # Преобразует символьные выражения в числовые

if __name__ == '__main__':
    t0 = float(input("Введите начальное время (ex = 0): "))
    t_end = float(input("Введите конечное время (ex = 0.5): "))
    plot(ode_num.rhs, (t, t0, t_end))     # Построение графика угловой скорости в зависимости от времени