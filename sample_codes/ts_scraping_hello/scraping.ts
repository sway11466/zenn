import puppeteer from "puppeteer";

const main = async () => {
  const browser = await puppeteer.launch()
  const page = await browser.newPage()
  await page.goto("https://zenn.dev")

  // トップページの記事タイトルを列挙する
  const titles = await page.$$eval('h2', list => list.map(e => e.textContent))
  console.log(titles)

  // トップページのスクショを作成する
  await page.screenshot({ path: "C:/typescript/zenntop.png" });

  await browser.close()
}

main()
