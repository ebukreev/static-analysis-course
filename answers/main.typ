#let project(title: "", authors: (), body) = {
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center)
  set text(font: "Linux Libertine", lang: "ru")

  align(center)[
    #block(text(weight: 700, 1.75em, title))
  ]

  pad(
    top: 0.5em,
    bottom: 0.5em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center, strong(author))),
    ),
  )

  set par(justify: true)

  body
}

#show: project.with(
  title: "Ответы на вопросы с лекций",
  authors: (
    "Евгений Букреев",
  ),
)

= 02-simple

  \
  1. Что будет, если в нашу систему ввести тип Bool?
  Перепишем правила (те, которые не выписаны, оставлены без изменений):

  #align(center)[
  $E_1 > E_2: [|E_1|] = [|E_2|] = "int" and [|E_1 > E_2|] = "bool"$\
  $E_1 == E_2: [|E_1|] = [|E_2|] and [|E_1==E_2|] = "bool"$\
  $E_1 op E_2: [|E_1|] = [|E_2|] = [|E_1 op E_2|] = "int"$\
  $"output" E: [|E|] = alpha$\
  $"if" (E) S: [|E|] = "bool"$\
  $"if" (E) S_1 "else" S_2: [|E|] = "bool"$\
  $"while" (E) S: [|E|] = "bool"$]
  
  Полученный анализ не изменит точность, потому что он был и есть soundness. Но снизится полнота, потому что станут отвергаться некоторые выражения, которые имеют корректную семантику. Например, (x == y) + 1.
  
  \

  2. Что будет, если в нашу систему ввести тип Array?
  Дополним правила типизации новыми конструкциями. Старые остались без изменений.

    #align(center)[
    ${} : [| {} |] = alpha[]$\
    ${E_1,...,E_n} : [|E_1|] = ... = [|E_n|] and [| {E_1,...,E_n} |] = [|E_1|][]$\
    $E[E_1] : [|E|] = alpha[] and [|E_1|] = "int" and [|E[E_1]|] = alpha$\
    $E[E_1] = E_2 : [|E|] = alpha[] and [|E_1|] = "int" and [|E_2|] = alpha$]

    Протипизируем программу со слайда:
  #align(center)[
    ```c
    main() {
      var x,y,z,t;
      x = {2,4,8,16,32,64}; // [|x|] = [|{2,4,8,16,32,64}|]
      y = x[x[3]];          // [|y|] = [|x[x[3]]|]
      z = {{},x};           // [|z|] = [|{{},x}|]
      t = z[1];             // [|t|] = [|z[1]|]
      t[2] = y;             // [|t|] = alpha[] and [|y|] = alpha
    }
    ```]

    Решим уравнения:
      #align(center)[
    $[|x|] = "int"[]$\
    $[|y|] = "int"$\
    $[|z|] = "int[][]"$\
    $[|t|] = "int[]"$\
  ]

  3. Подумайте, что происходит в получившейся реализации, если в программе есть рекурсивный тип? 

  Тогда программа все равно типизируется, т.к. используется регулярная унификация на основе Union-Find и регулярные рекурсивные термы разрешены.

  #pagebreak()

= 03-lattices

\

1. 