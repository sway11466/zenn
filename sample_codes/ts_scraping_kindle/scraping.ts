import puppeteer from "puppeteer";

const main = async () => {

  // トップページを表示する
  const browser = await puppeteer.launch()
  const page = await browser.newPage()
  await page.goto("https://read.amazon.co.jp")

  // ログインページに遷移する
  await page.waitForSelector("#top-sign-in-btn")
  await page.click("#top-sign-in-btn")
 
  // Eメールとパスワードを入力してログインする
  await page.waitForSelector("#signInSubmit")
  await page.type("input[name=email]", "email address")
  await page.type("input[name=password]", "password")
  await page.click("#signInSubmit")
 
  // APIを直にたたいて蔵書をjsonで取得する（ブラウザのセッションをそのまま使う）
  // 50件ずつしか取得できないようなので繰り返し取得する
  await page.waitForNavigation()
  let books:any = []
  for (let paginationToken=0; paginationToken != undefined;) {
    await page.goto("https://read.amazon.co.jp/kindle-library/search?&sortType=acquisition_asc&paginationToken=" + paginationToken)
    const respons = JSON.parse((await page.$eval("pre", e => e.textContent)) ?? "{}")
    books = books.concat(respons.itemsList)
    paginationToken = respons.paginationToken
  }

  // タイトルと冊数を出力する
  books.map((book:any) => console.log(book.title))
  console.log("蔵書数は" + books.length + "冊です。")

  await browser.close()
}

main()
