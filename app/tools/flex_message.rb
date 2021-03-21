class FlexMessage
  class << self

    def hit_success(name, account, location, time)
      {
        type: 'flex',
        altText: '打卡',
        contents: {
          type: "bubble",
          direction: "ltr",
          header: {
            type: "box",
            layout: "vertical",
            contents: [
              {
                type: "text",
                text: name,
                weight: "bold",
                size: "xl",
                align: "center",
                contents: []
              },
              {
                type: "text",
                text: account,
                weight: "bold",
                size: "xl",
                align: "center",
                contents: []
              }
            ]
          },
          body: {
            type: "box",
            layout: "vertical",
            contents: [
              {
                type: "text",
                text: "打卡成功",
                weight: "bold",
                size: "3xl",
                align: "center",
                contents: []
              }
            ]
          },
          footer: {
            type: "box",
            layout: "vertical",
            contents: [
              {
                type: "separator"
              },
              {
                type: "text",
                text: "座標",
                align: "center",
                margin: "lg",
                contents: []
              },
              {
                type: "text",
                text: location,
                align: "center",
                contents: []
              },
              {
                type: "text",
                text: "時間",
                align: "center",
                contents: []
              },
              {
                type: "text",
                text: time,
                align: "center",
                contents: []
              }
            ]
          }
        }
      }
    end

    def record(name, account, card_in, card_out, all_cards)
      all_card_message = all_cards.split(' ').map { |time| time.insert(2, ':')}.join(', ')
      {
        type: 'flex',
        altText: '紀錄',
        contents: {
          type: "bubble",
          direction: "ltr",
          header: {
            type: "box",
            layout: "vertical",
            contents: [
              {
                type: "text",
                text: name,
                weight: "bold",
                size: "xl",
                align: "center",
                contents: []
              },
              {
                type: "text",
                text: account,
                weight: "bold",
                size: "xl",
                align: "center",
                contents: []
              }
            ]
          },
          body: {
            type: "box",
            layout: "vertical",
            contents: [
              {
                type: "text",
                text: "出勤紀錄",
                weight: "bold",
                size: "xl",
                align: "center",
                contents: []
              },
              {
                type: "separator",
                margin: "md"
              },
              {
                type: "box",
                layout: "horizontal",
                margin: "md",
                contents: [
                  {
                    type: "text",
                    text: "進卡：",
                    size: "lg",
                    align: "center",
                    contents: []
                  },
                  {
                    type: "text",
                    text: card_in.empty? ? '-' : card_in,
                    size: "lg",
                    align: "center",
                    contents: []
                  }
                ]
              },
              {
                type: "box",
                layout: "horizontal",
                contents: [
                  {
                    type: "text",
                    text: "出卡：",
                    size: "lg",
                    align: "center",
                    contents: []
                  },
                  {
                    type: "text",
                    text: card_out.empty? ? '-' : card_out,
                    size: "lg",
                    align: "center",
                    contents: []
                  }
                ]
              }
            ]
          },
          footer: {
            type: "box",
            layout: "vertical",
            contents: [
              {
                type: "separator",
                margin: "xs"
              },
              {
                type: "text",
                text: "所有紀錄",
                align: "center",
                margin: "lg",
                contents: []
              },
              {
                type: "text",
                text: all_cards.split(' ').map { |time| time.insert(2, ':')}.join(', ') || '-',
                align: "center",
                margin: "md",
                wrap: true,
                contents: []
              }
            ]
          }
        }
      } 
    end

    def single_error(error)
      {
        type: "box",
        layout: "vertical",
        contents: [
          {
            type: "separator",
            margin: "lg"
          },
          {
            type: "text",
            text: error[:date],
            size: "lg",
            align: "center",
            margin: "md",
            contents: []
          },
          {
            type: "box",
            layout: "horizontal",
            contents: [
              {
                type: "text",
                text: "進卡：",
                size: "md",
                align: "center",
                contents: []
              },
              {
                type: "text",
                text: error[:card_in].empty? ? '-' : error[:card_in],
                size: "md",
                align: "center",
                contents: []
              }
            ]
          },
          {
            type: "box",
            layout: "horizontal",
            contents: [
              {
                type: "text",
                text: "出卡：",
                size: "md",
                align: "center",
                contents: []
              },
              {
                type: "text",
                text: error[:card_out].empty? ? '-' : error[:card_out],
                size: "md",
                align: "center",
                contents: []
              }
            ]
          },
          {
            type: "box",
            layout: "horizontal",
            contents: [
              {
                type: "text",
                text: "訊息：",
                size: "md",
                align: "center",
                contents: []
              },
              {
                type: "text",
                text: error[:message],
                size: "md",
                align: "center",
                contents: []
              }
            ]
          }
        ]
      }
    end

    def error_info(name, account, errors)
      {
        type: 'flex',
        altText: '異常',
        contents: {
          type: "bubble",
          direction: "ltr",
          header: {
            type: "box",
            layout: "vertical",
            contents: [
              {
                type: "text",
                text: name,
                weight: "bold",
                size: "xl",
                align: "center",
                contents: []
              },
              {
                type: "text",
                text: account,
                weight: "bold",
                size: "xl",
                align: "center",
                contents: []
              }
            ]
          },
          body: {
            type: "box",
            layout: "vertical",
            contents: [
              {
                type: "text",
                text: "出勤異常",
                weight: "bold",
                size: "xl",
                align: "center",
                contents: []
              }
            ] + errors.map { |error| single_error(error) }
          }
        }
      }
    end
  end
end